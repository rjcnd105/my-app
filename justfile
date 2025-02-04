# 기본 셸 스크립트 실행을 위한 레시피
@_shell-run command:
    #!/usr/bin/env sh
    set -euxo pipefail
    {{command}} 

# Umbrella 디렉토리에서 명령어 실행을 위한 레시피
@_umbrella-run command:
    #!/usr/bin/env sh
    set -euxo pipefail
    cd $PROJECT_NAME"_umbrella" && {{command}}

@dev-up: (_shell-run "nix run .#app-services --impure") 

@web-router: (_umbrella-run "mix phx.routes DutchpayWeb.Router")

@start: (_umbrella-run "mix phx.server")

@istart: (_umbrella-run "iex -S mix phx.server")

@psql: (_shell-run "psql -U postgres -h localhost")
