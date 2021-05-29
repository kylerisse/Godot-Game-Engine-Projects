.EXPORT_ALL_VARIABLES:
GIT_SHA=$(shell git rev-parse --short HEAD)
IMAGE=godot-game-engine-projects

coin-dash:
	mkdir -p build/coin-dash/
	cd Chapter2-CoinDash && godot3 -v --export "HTML5" ../build/coin-dash/index.html; cd ..

escape-the-maze:
	mkdir -p build/escape-the-maze/
	cd Chapter3-EscapeTheMaze && godot3 -v --export "HTML5" ../build/escape-the-maze/index.html; cd ..

space-rocks:
	mkdir -p build/space-rocks/
	cd Chapter4-SpaceRocks && godot3 -v --export "HTML5" ../build/space-rocks/index.html; cd ..

docker:
	cp html/index.html build/
	docker build -t ${IMAGE}:${GIT_SHA} .

test:
	docker run -p 8080:80 ${IMAGE}:${GIT_SHA}

clean:
	rm -rf build/
	docker rmi -f $$(docker images | grep "${IMAGE}\|<none>" | awk '{print $$3}')

build: coin-dash escape-the-maze space-rocks docker
