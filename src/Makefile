apps:='apache' 'goodbyeworld' 'helloworld' 'nameapi'

rebuild: 
	@echo "rebuild"
	sh docker-build.sh
install:
	kubectl apply -f infrastructure.yaml
	kubectl apply -f microservices.yaml

init: 
	@eval $(minikube -p minikube docker-env)

load:	
	@echo "gen load"
	@for app in $(apps) ; do \
		echo load $$app ; \
		sh load.sh `minikube service $$app --url` >> $$app.log & \
	done
ports: 
	@echo "show ports"
	minikube service apache --url
	minikube service goodbyeworld --url
	minikube service helloworld --url
	minikube service nameapi --url
error: 
	kubectl apply -f fault-injection.yaml

bg:
	kubectl apply -f bluegreen.yaml

clean: 
	kubectl delete -f microservices.yaml
	kubectl delete -f infrastructure.yaml
	kubectl delete -f bluegreen.yaml
#	kubectl delete -f fault-injection.yaml
update: clean rebuild install bg


#	@for app in $(apps) ; do \
#		echo port $$app ; \
#		minikube service $$app --url \
#	done
