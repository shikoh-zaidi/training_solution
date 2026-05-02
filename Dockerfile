# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy rest of the code
COPY . ./

RUN dotnet restore

RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Set environment
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# Copy build output
COPY --from=build /app/publish .

# Expose port
EXPOSE 5000

ENTRYPOINT ["dotnet", "WebApplication1.dll"]
