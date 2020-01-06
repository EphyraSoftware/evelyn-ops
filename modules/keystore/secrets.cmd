rem Remove the tmp directory and recreated it to force update of bundles.
rmdir /Q /S tmp
mkdir tmp

pushd tmp

rem Copy the trust store.
copy \\nas.evelyn.internal\terraform\.files\bundles\truststore.p12 truststore.p12

rem Copy the key stores.
copy \\nas.evelyn.internal\terraform\.files\bundles\web-entry-point-keystore.p12 web-entry-point-keystore.p12
copy \\nas.evelyn.internal\terraform\.files\bundles\profile-service-keystore.p12 profile-service-keystore.p12
copy \\nas.evelyn.internal\terraform\.files\bundles\group-service-keystore.p12 group-service-keystore.p12

rem Remove the existing secrets.
kubectl -n evelyn-services delete secret web-entry-point-keystore
kubectl -n evelyn-services delete secret profile-service-keystore
kubectl -n evelyn-services delete secret group-service-keystore

rem Create the secrets.
kubectl -n evelyn-services create secret generic web-entry-point-keystore --from-file=./web-entry-point-keystore.p12 --from-file=./truststore.p12
kubectl -n evelyn-services create secret generic profile-service-keystore --from-file=./profile-service-keystore.p12 --from-file=./truststore.p12
kubectl -n evelyn-services create secret generic group-service-keystore --from-file=./group-service-keystore.p12 --from-file=./truststore.p12

popd
