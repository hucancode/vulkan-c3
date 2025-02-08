release: main.odin shader
	c3c run
debug: main.odin shader
	c3c run -debug
shader: src/shaders/shader.vert src/shaders/shader.frag
	glslc src/shaders/shader.vert -o src/shaders/vert.spv
	glslc src/shaders/shader.frag -o src/shaders/frag.spv
