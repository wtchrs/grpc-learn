#!/usr/bin/env bash

printf "Generate stubs\n\n"

PROTO_PATH="./proto"
OUTPUT_PATH=(
  "./productinfo/service"
  "./productinfo/client"
)

SUCCESS=true

for PATH in "${OUTPUT_PATH[@]}"
do
  printf "Start generating in %s\n" "${PATH}"

  protoc \
    --proto_path="${PROTO_PATH}" \
    ecommerce/product_info.proto \
    --go_out="${PATH}" \
    --go_opt=paths=source_relative \
    --go-grpc_out="${PATH}" \
    --go-grpc_opt=paths=source_relative

  if [ $? -eq 0 ]; then
    printf "Successfully generated in %s\n\n" "${PATH}"
  else
    printf "Failed to generate in %s\n\n" "${PATH}"
    SUCCESS=false
  fi
done

if $SUCCESS; then
  echo "Successfully generated in all paths"
else
  echo "Failed to generate stubs in some paths"
fi
