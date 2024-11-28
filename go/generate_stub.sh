#!/usr/bin/env bash

printf "Generate stubs\n\n"

if ! [ -x "$(command -v protoc)" ]; then
  echo "protoc does not exist"
  exit 1
fi

PROTO_PATH="./proto"
OUTPUT_PATHS=(
  "./productinfo/service"
  "./productinfo/client"
)

SUCCESS=true

for OUTPUT_PATH in "${OUTPUT_PATHS[@]}"
do
  printf "Start generating in %s\n" "${OUTPUT_PATH}"

  protoc \
    --proto_path="${PROTO_PATH}" \
    ecommerce/product_info.proto \
    --go_out="${OUTPUT_PATH}" \
    --go_opt=paths=source_relative \
    --go-grpc_out="${OUTPUT_PATH}" \
    --go-grpc_opt=paths=source_relative

  if [ $? -eq 0 ]; then
    printf "Successfully generated in %s\n\n" "${OUTPUT_PATH}"
  else
    printf "Failed to generate in %s\n\n" "${OUTPUT_PATH}"
    SUCCESS=false
  fi
done

if $SUCCESS; then
  echo "Successfully generated in all paths"
else
  echo "Failed to generate stubs in some paths"
fi
