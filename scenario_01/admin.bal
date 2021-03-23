import  ballerina/http;

http:ListenerConfiguration helloWorldEPConfig = {
    secureSocket: {
        key: {
            certFile: "public.cert",
            keyFile: "private.key"
        }
    }
};

listener http:Listener securedEp = new (9091, helloWorldEPConfig);

@http:ServiceConfig {
    auth: [
        {
            ldapUserStoreConfig: {
                domainName: "ballerina.io",
                connectionUrl: "ldap://localhost",
                connectionName: "uid=admin,ou=system",
                connectionPassword: "secret",
                userSearchBase: "ou=Users,dc=ballerina,dc=io",
                userEntryObjectClass: "identityPerson",
                userNameAttribute: "uid",
                userNameSearchFilter: "(&(objectClass=person)(uid=?))",
                userNameListFilter: "(objectClass=person)",
                groupSearchBase: ["ou=Groups,dc=ballerina,dc=io"],
                groupEntryObjectClass: "groupOfNames",
                groupNameAttribute: "cn",
                groupNameSearchFilter: "(&(objectClass=groupOfNames)(cn=?))",
                groupNameListFilter: "(objectClass=groupOfNames)",
                membershipAttribute: "member",
                userRolesCacheEnabled: true,
                connectionPoolingEnabled: false,
                connectionTimeout: 5000,
                readTimeout: 60000
            },
            scopes: ["Admin"]
        }
    ]
}

service /admin on securedEp {
    resource function get .() returns string {

        return "Successful";
    }

    resource function get adminjwt() returns string {

        return "Successful";
    }
}