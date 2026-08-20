shader_type canvas_item;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    // 如果距离大于 0.5（超出了圆的半径），则让该像素完全透明
    if (length(uv) > 0.5) {
        COLOR.a = 0.0;
    }
}