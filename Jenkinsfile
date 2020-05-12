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
				                    sh 'docker build --network=host -f "Dockerfile" -t 127.0.0.1:5000/tofomvc:1.1.$BUILD_NUMBER-prod .'
                        }
                }	
            }

            stage('Push Docker Image') {
                container('docker') {
                        docker.withRegistry('127.0.0.1:5000') {
                            sh 'docker push 127.0.0.1:5000/tofomvc:1.1.$BUILD_NUMBER-prod'
                        }
                }	
            }

            stage ('Deploy') {
                container('docker') {
                            sh 'sed -e "s|BUILD_NUMBER|$BUILD_NUMBER|g" deployment.yaml'
                            sh 'docker run buoyantio/kubectl:latest apply -f deployment.yaml'
                            // sh "ansible-playbook -i inventory playbook.yml --extra-vars \"build_number=${build_number}\" -vvv"
                }   
            }	
    }
}
