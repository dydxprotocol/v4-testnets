FROM alpine:3.18

RUN apk add --no-cache jq curl

ENV HOME /dydxprotocol
WORKDIR /workspace

ENTRYPOINT ["sh", "/workspace/validate.sh"]
