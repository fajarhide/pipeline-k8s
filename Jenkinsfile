podTemplate(containers: [
    containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
  ) {
    node(POD_LABEL) {
            stage('Checkout') {
            checkout scm
            }

            stage('Build Docker Image') {
                container('docker') {
                        docker.withRegistry('127.0.0.1:5000') {
				            sh 'docker build --network=host -f "Dockerfile" -t 127.0.0.1:5000/pipeline-k8s:$BUILD_NUMBER .'
                        }
                }	
            }

            stage('Push Docker Image') {
                container('docker') {
                        docker.withRegistry('127.0.0.1:5000') {
                            sh 'docker push 127.0.0.1:5000/pipeline-k8s:$BUILD_NUMBER'
                        }
                }	
            }

            stage ('Deploy') {
                container('docker') {
                            sh 'sed -e "s|BUILD_NUMBER|$BUILD_NUMBER|g" deployment.yaml > deploy.yaml'
                            sh 'kubectl apply -f deploy.yaml'
                }   
            }	
    }
}
