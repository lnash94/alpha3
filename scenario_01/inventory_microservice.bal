import ballerina/http;
import ballerina/jwt;
import ballerina/io;

# Description
#
# + jwt - Parameter string type jwt token
# + return - Return Value http response  
public function validate(string jwt) returns http:Response|error {
    http:Response outResponse = new;
    jwt:ValidatorConfig validatorConfig = {
        issuer: "ballerina",
        audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
        clockSkew: 60,
        signatureConfig: {jwksConfig: {
                url: "https://localhost:9443/oauth2/token",
                clientConfig: {secureSocket: {cert: "public.crt"}}
            }}
    };
    jwt:Payload result = check jwt:validate(jwt, validatorConfig);
    if (result is jwt:Payload) {
        io:println("Validated JWT Payload: ", result.toString());
        // return responses
        outResponse.statusCode = 200;
        json|error payload = result.cloneWithType(json);
        if payload is json {
            outResponse.setPayload(payload);
        } else {
            outResponse.statusCode = 403;
        }
        return outResponse;
    } else {
        io:println("An error occurred while validating the JWT: ", result.message());
        outResponse.statusCode = 401;
        return outResponse;
    }
}
