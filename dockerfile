ARG REPO=mcr.microsoft.com/dotnet/aspnet
FROM $REPO:8.0.0-jammy-amd64

ENV \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=8.0.100 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-22.04


# Install required packages for adding a new repository
RUN apt-get update && apt-get install -y ca-certificates curl gnupg

# Add the NodeSource GPG key
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg

# Add the NodeSource repository for Node.js 20
RUN echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x jammy main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x jammy main" | tee -a /etc/apt/sources.list.d/nodesource.list

# Install Node.js and other dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        wget \
        lua5.1 \
        luarocks \
        cmake \
        build-essential \
        nodejs \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='13905ea20191e70baeba50b0e9bbe5f752a7c34587878ee104744f9fb453bfe439994d38969722bdae7f60ee047d75dda8636f3ab62659450e9cd4024f38b2a5' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.4.0 \
    && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://powershellinfraartifacts-gkhedzdeaghdezhr.z01.azurefd.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='b7e5fcd8881309093e0010c559ff416ab8c51e82c6c348effccc6b9eb3bb345821f3f91b44678fc2eea2a86cffcd163909ab045c0fe70a168d01806ca15f7138' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm


#configure ssh usage, this needs mounted from the host machine to work with -v /path/to/.ssh/id_ed25519:/root/.ssh/id_ed25519:ro
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Set up LuaRocks for LuaJIT
# This assumes Lua 5.1 is compatible with LuaJIT for your needs
RUN luarocks install busted
RUN luarocks install lua-messagepack
RUN luarocks install redis-lua
RUN luarocks install luasocket
RUN luarocks install rapidjson

#expose port 5173
EXPOSE 5173

# Copy the shell script into the container
COPY configure-git.sh /root/configure-git.sh
RUN chmod +x /root/configure-git.sh


# Set the entrypoint script
ENTRYPOINT [ "/root/configure-git.sh" ]