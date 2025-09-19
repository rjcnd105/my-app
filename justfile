# 기본 셸 스크립트 실행을 위한 레시피
@_shell-run command:
    #!/usr/bin/env sh
    set -euxo pipefail
    {{command}}

@dev-up: (_shell-run "nix run .#app-services --impure")

@db-up: (_shell-run "cd deopjib_db && nix run .#app-services --impure")

# @web-router: (_umbrella-run "mix phx.routes DutchpayWeb.Router")

# @start: (_umbrella-run "mix phx.server")

# @istart: (_umbrella-run "iex -S mix phx.server")

@psql: (_shell-run "psql -U postgres -h localhost")

# @read-postmaster-id: (_shell-run "cat /Users/hj/study_ex/my-backend/data/pg/postmaster.pid")
@vps: (_shell-run "sops exec-env ./secrets/shared/secrets.yaml 'ssh $VPS_USER_NAME@$VPS_HOST -p $VPS_PORT'")

@env: (_shell-run "nix develop --impure")
