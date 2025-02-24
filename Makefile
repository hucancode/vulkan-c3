release: src/main.c3 shader
	c3c run
debug: src/main.c3 shader
	c3c run -g
shader: src/shaders/shader.vert src/shaders/shader.frag
	glslc src/shaders/shader.vert -o src/shaders/vert.spv
	glslc src/shaders/shader.frag -o src/shaders/frag.spv
develop:
	nix develop --command $$SHELL
