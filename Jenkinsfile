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
                stage('List pods') {
                    withKubeConfig([credentialsId: '33d62c96-85a1-4b0c-be97-7756bccea24b',
                    serverUrl: 'https://kubernetes.docker.internal:6443'
                    ]) {
                        sh 'kubectl get pods'
                }
            }	
    }
}
