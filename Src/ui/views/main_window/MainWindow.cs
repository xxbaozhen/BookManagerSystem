using Godot;
using System;
using System.Runtime.InteropServices;

public partial class MainWindow : Control
{
	// --- 引入 Windows 核心系统库 API ---
	
	// 设置窗口的有效点击与渲染区域
	[DllImport("user32.dll")]
	private static extern int SetWindowRgn(IntPtr hWnd, IntPtr hRgn, bool bRedraw);

	// 创建一个圆角矩形区域 (Region)
	[DllImport("gdi32.dll")]
	private static extern IntPtr CreateRoundRectRgn(
		int nLeftRect,
		int nTopRect,
		int nRightRect,
		int nBottomRect,
		int nWidthEllipse,
		int nHeightEllipse
	);

	// 释放 Region 对象（仅在 SetWindowRgn 失败时使用；成功后系统接管该 Region）
	[DllImport("gdi32.dll")]
	private static extern bool DeleteObject(IntPtr hObject);

	// --- 节点引用与参数 ---
	private Control _shadowPanel;

	private int _cornerRadius = 15;

	[Export]
	public int CornerRadius
	{
		get => _cornerRadius;
		set
		{
			_cornerRadius = value;
			// 编辑器或运行时修改圆角半径后，立即刷新窗口区域
			if (IsNodeReady())
			{
				UpdateWindowRegion();
			}
		}
	}

	public override void _Ready()
	{
		// 1. 确保 Godot 引擎层面的 Viewport 背景透明
		GetViewport().TransparentBg = true;

		// 2. 根据您的节点树结构获取实体面板
		_shadowPanel = GetNode<Control>("MainMargin/ShadowPanel");

		if (_shadowPanel == null)
		{
			GD.PrintErr("错误：未找到 ShadowPanel 节点，请检查路径是否正确！");
			return;
		}

		// 3. 核心：监听尺寸变化信号。当窗口缩放或 UI 布局改变时，自动重新计算穿透区域
		_shadowPanel.Resized += OnShadowPanelResized;

		// 4. 延迟一帧执行，等待 Godot 的 MarginContainer 等容器完成首次布局计算
		CallDeferred(MethodName.UpdateWindowRegion);
	}

	// 当面板尺寸发生改变时的回调
	private void OnShadowPanelResized()
	{
		UpdateWindowRegion();
	}

	// 刷新窗口物理区域的核心方法
	private void UpdateWindowRegion()
	{
		if (_shadowPanel == null) return;

		// 步骤 1: 获取当前操作系统的窗口句柄 (HWND)
		long hwndLong = DisplayServer.WindowGetNativeHandle(DisplayServer.HandleType.WindowHandle);
		IntPtr hwnd = (IntPtr)hwndLong;

		if (hwnd == IntPtr.Zero)
		{
			GD.PrintErr("无法获取窗口系统句柄 HWND");
			return;
		}

		// 步骤 2: 获取 ShadowPanel 相对于整个窗口的全局矩形范围 (Position 和 End)
		// 注意：Godot 返回的是逻辑像素，而 Win32 区域 API 需要物理像素。
		// 当 Windows 显示缩放不为 100% 时二者不一致，需乘以窗口内容缩放系数换算。
		Rect2 solidRect = _shadowPanel.GetGlobalRect();
		float scale = GetWindow().ContentScaleFactor;

		int left = Mathf.RoundToInt(solidRect.Position.X * scale);
		int top = Mathf.RoundToInt(solidRect.Position.Y * scale);
		int right = Mathf.RoundToInt(solidRect.End.X * scale);
		int bottom = Mathf.RoundToInt(solidRect.End.Y * scale);

		// Win32 API 需要的是圆角椭圆的直径（宽和高），所以半径需要乘以 2
		int ellipseDiameter = Mathf.RoundToInt(CornerRadius * 2 * scale);

		// 步骤 3: 创建系统级圆角矩形区域
		IntPtr hRgn = CreateRoundRectRgn(
			left,
			top,
			right,
			bottom,
			ellipseDiameter, // 圆角宽度
			ellipseDiameter  // 圆角高度
		);

		// 步骤 4: 告知 Windows 操作系统重塑该窗口的物理边界
		// 成功调用后，该区域外的鼠标事件将直接穿透到底层桌面，且区域外不进行画面渲染
		int result = SetWindowRgn(hwnd, hRgn, true);

		if (result == 0)
		{
			// 设置失败时系统不会接管该 Region，手动释放避免 GDI 句柄泄漏
			DeleteObject(hRgn);
			GD.PrintErr("SetWindowRgn 调用失败");
		}
	}
}
