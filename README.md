### Kubernetes Helm charts ###

  - **Add snappyflow helm chart repo**
	
	```
	$ helm repo add snappyflow https://raw.githubusercontent.com/snappyflow/helm-charts/master
	"snappyflow" has been added to your repositories
	```
	
  - **Check repo added**
	```
	$ helm repo list
	NAME      		URL                                                            
	stable    		https://kubernetes-charts.storage.googleapis.com               
	local     		http://127.0.0.1:8879/charts                                                                                     
	snappyflow		https://raw.githubusercontent.com/snappyflow/helm-charts/master
	```
  - **Update Helm repo**	
	```
	$ helm repo update
	```
	
  - **Search all available charts in snappyflow repo**
	```
	$ helm search snappyflow/
	
	NAME                            	CHART VERSION	APP VERSION         	DESCRIPTION                                                 

	snappyflow/elasticsearch        	0.2.8        	                    	This Elasticsearch cluster supports 3 master nodes, 2 dat...

	snappyflow/expresscart          	0.1.7        	1.0                 	A Helm chart to deploy expressCart nodejs application       

	snappyflow/fluentd-elasticsearch	2.0.8        	2.3.2               	A Fluentd Helm chart for Kubernetes with Elasticsearch ou...

	snappyflow/petclinic            	0.2.6        	2.1.0.BUILD-SNAPSHOT	Helm chart for deploying basic Spring applications          

	snappyflow/petclinic-v3         	0.4.0        	2.1.0.BUILD-SNAPSHOT	Helm chart for deploying basic Spring applications          

	snappyflow/sample-petclinic     	1.0.0        	1                   	Helm chart for deploying basic Spring applications          

	snappyflow/sfagent              	2.0.0        	1.0                 	Cluster and Application Monitoring system for Maplelabs' ...

	```
	
  - **Get values.yaml content**	
	```
	$ helm inspect snappyflow/petclinic
	```
	
  - **Note: Below commands are applicable for Helm version 2. Commands has changed for Helm version 3**

  - **Install with Default values**	
	```
	$ helm install snappyflow/sample-petclinic --name my-app --namespace my-namespace
	```
	
  - **Install with command line argument to set parameters**	
	```
	$ helm install snappyflow/sample-petclinic --set global.sfappname=my-app --set global.sfprojectname=my-project --name my-app --namespace my-namespace
	```
	
  - **Install with file as input to set parameters**	
	```
	$ helm install snappyflow/sample-petclinic -f inputfile.yaml --name my-app --namespace my-namespace
	```
	
  - **Check if app is installed**
	```
	$ helm list -a
	
	NAME     	REVISION	UPDATED                 	STATUS  	CHART              	APP VERSION         	NAMESPACE 

	my-app	    1       	Fri Apr  3 17:50:53 2020	DEPLOYED	sample-petclinic-1.0.0	1          	default  
	
	```
	
  - **Delete an app**
	```
	$ helm delete my-app --purge
	```



