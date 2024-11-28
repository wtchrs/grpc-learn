#!/usr/bin/env pwsh

Write-Output "Generate stubs`n"

if (-not (Get-Command protoc -ErrorAction SilentlyContinue)) {
    Write-Output "protoc does not exist`n"
    exit 1
}

# Define paths
$PROTO_PATH = "./proto"
$OUTPUT_PATHS = @(
    "./productinfo/service"
    "./productinfo/client"
)

$SUCCESS = $true

foreach ($OUTPUT_PATH in $OUTPUT_PATHS) {
    Write-Output "Start generating in $OUTPUT_PATH"

    protoc `
        --proto_path=$PROTO_PATH `
        ecommerce/product_info.proto `
        --go_out=$OUTPUT_PATH `
        --go_opt=paths=source_relative `
        --go-grpc_out=$OUTPUT_PATH `
        --go-grpc_opt=paths=source_relative

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Successfully generated in $OUTPUT_PATH`n"
    } else {
        Write-Output "Failed to generate in $OUTPUT_PATH`n"
        $SUCCESS = $false
    }
}

if ($SUCCESS) {
    Write-Output "Successfully generated in all paths"
} else {
    Write-Output "Failed to generate stubs in some paths"
}
