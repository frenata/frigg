FROM python:3.13-bookworm

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=ghcr.io/atuinsh/atuin:latest /usr/local/bin /bin/
COPY images/scripts /opt/scripts

# Remove cargo so rustup works...
RUN apt update && apt remove -y cargo rust-all && apt install -y curl tar xz-utils

# Install the rust toolchain since some python wheels aren't available for 3.14 yet
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup update

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /bin

RUN echo 'install bash-preexec' && \
    curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o /opt/bash-preexec.sh

ENV UV_PROJECT_ENVIRONMENT /tmp/venv

WORKDIR /workspaces/frigg

COPY pyproject.toml .
COPY uv.lock .
RUN uv sync

ENTRYPOINT [ "just", "run" ]
