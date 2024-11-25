#!/usr/bin/env pwsh

Write-Output "Generate stubs`n"

# Define paths
$PROTO_PATH = "./proto"
$OUTPUT_PATHS = @(
    "./productinfo/service"
    "./productinfo/client"
)

$SUCCESS = $true

foreach ($PATH in $OUTPUT_PATHS) {
    Write-Output "Start generating in $PATH"

    protoc `
        --proto_path=$PROTO_PATH `
        ecommerce/product_info.proto `
        --go_out=$PATH `
        --go_opt=paths=source_relative `
        --go-grpc_out=$PATH `
        --go-grpc_opt=paths=source_relative

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Successfully generated in $PATH`n"
    } else {
        Write-Output "Failed to generate in $PATH`n"
        $SUCCESS = $false
    }
}

if ($SUCCESS) {
    Write-Output "Successfully generated in all paths"
} else {
    Write-Output "Failed to generate stubs in some paths"
}
