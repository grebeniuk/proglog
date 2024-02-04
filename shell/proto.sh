wget https://github.com/protocolbuffers/protobuf/releases/download/v3.9.1/protoc-3.9.1-linux-x86_64.zip
sudo unzip ./protoc-3.9.1-linux-x86_64.zip -d /usr/local/protobuf
tree /usr/local/protobuf
echo 'export PATH="$PATH:/usr/local/protobuf/bin"' >> ~/.bashrc

# get prodobuf Go runtime v2
go install google.golang.org/protobuf/...@v1.25.0
#compile protobuf
protoc api/v1/*.proto --go_out=. --go_opt=paths=source_relative --proto_path=.

go get google.golang.org/grpc@v1.32.0
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest