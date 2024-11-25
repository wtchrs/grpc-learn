package ecommerce;

import io.grpc.StatusException;
import io.grpc.stub.StreamObserver;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import static ecommerce.ProductInfoGrpc.*;
import static ecommerce.ProductInfoOuterClass.*;
import static io.grpc.Status.*;

public class ProductInfoImpl extends ProductInfoImplBase {

    private final Map<String, Product> productMap = new ConcurrentHashMap<>();

    @Override
    public void addProduct(Product request, StreamObserver<ProductID> responseObserver) {
        UUID uuid = UUID.randomUUID();
        String randomUUIDString = uuid.toString();
        request = request.toBuilder().setId(randomUUIDString).build();
        productMap.put(randomUUIDString, request);
        ProductID response = ProductID.newBuilder().setValue(randomUUIDString).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getProduct(ProductID request, StreamObserver<Product> responseObserver) {
        Optional.of(productMap.get(request.getValue())).ifPresentOrElse(
            product -> {
                responseObserver.onNext(product);
                responseObserver.onCompleted();
            },
            () -> responseObserver.onError(
                NOT_FOUND.withDescription("Product with ID: " + request.getValue() + " not found").asException())
        );
    }

}
