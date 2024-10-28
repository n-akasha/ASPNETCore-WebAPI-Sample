# Use the .NET Core SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the project files and restore dependencies
COPY SampleWebApiAspNetCore/*.csproj ./
RUN dotnet restore

# Copy the remaining files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use the smaller ASP.NET Core runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose port 7124 to the outside world
EXPOSE 7124


# Define the startup command
ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]