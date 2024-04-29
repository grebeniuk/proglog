helm create proglog
helm template proglog
rm proglog/templates/**/*.yaml proglog/templates/NOTES.txt

kind create cluster
kubectl cluster-info
kind load docker-image github.com/grebeniuk/proglog:0.0.1