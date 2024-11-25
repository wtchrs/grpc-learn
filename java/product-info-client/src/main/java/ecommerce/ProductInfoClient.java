package ecommerce;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

import static ecommerce.ProductInfoOuterClass.*;

public class ProductInfoClient {

    public static void main(String[] args) {
        ManagedChannel channel = ManagedChannelBuilder
            .forAddress("localhost", 50051)
            .usePlaintext()
            .build();

        ProductInfoGrpc.ProductInfoBlockingStub stub = ProductInfoGrpc.newBlockingStub(channel);

        ProductID productId = stub.addProduct(
            Product.newBuilder()
                .setName("Apple iPhone 11")
                .setDescription("Meet Apple iPhone 11. All-new dual-camera system with Ultra Wide and Night mode.")
                .setPrice(1000.0f)
                .build()
        );
        System.out.println(productId.getValue());

        Product product = stub.getProduct(productId);
        System.out.println(product);
    }

}
