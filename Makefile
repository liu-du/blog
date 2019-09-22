init:
	git submodule update --init
	$(MAKE) -C blog-container build

rstudio:
	@docker run -d -p 8787:8787 -p 4321:4321 -e PASSWORD=pw --name my_rstudio \
	-v $(shell pwd):/home/rstudio/blog \
	-v $(HOME)/.ssh:/home/rstudio/.ssh \
	-v $(HOME)/.rstudio-desktop/monitored/user-settings:/home/rstudio/.rstudio/monitored/user-settings \
	duliu/r-env && \
	echo "Rstudio available at http://localhost:8787. Username: rstudio, Password: pw"

shell:
	docker exec -it -u rstudio -w /home/rstudio my_rstudio bash || docker run --rm -u rstudio -w /home/rstudio -it duliu/r-env bash

stop:
	docker stop my_rstudio