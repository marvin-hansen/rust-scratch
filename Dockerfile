FROM rust:1.79-alpine3.19 as builder

# Create the user and group files to run the binary as an unprivileged user.
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group

############################
# Scratch image
############################
# Create minimal docker image
FROM scratch as runner

# Import user and group files from the build stage.
COPY --from=builder /user/group /user/passwd /etc/

# Import the CAcertificates from the build stage to enable HTTPS.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
