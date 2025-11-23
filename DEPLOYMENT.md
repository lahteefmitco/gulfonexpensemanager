# Deploying Gulfon Expense Manager to Render.com

This guide explains how to deploy your Flutter Web application to Render using Docker.

## Prerequisites

1.  **GitHub Repository**: Ensure your code is pushed to GitHub (which we have already done).
2.  **Render Account**: Create an account at [render.com](https://render.com).

## Steps

1.  **Log in to Render Dashboard**.
2.  Click on the **New +** button and select **Web Service**.
3.  **Connect your Repository**:
    *   Find `gulfonexpensemanager` in the list and click **Connect**.
    *   If you don't see it, ensure you've granted Render access to your GitHub account/repositories.
4.  **Configure the Service**:
    *   **Name**: Enter a name (e.g., `gulfon-expense-manager`).
    *   **Region**: Select the region closest to your users (e.g., `Singapore` or `Frankfurt`).
    *   **Branch**: Ensure `main` is selected.
    *   **Runtime**: Select **Docker** (This is crucial).
    *   **Instance Type**: Select **Free** (for hobby projects) or a paid plan for better performance.
5.  **Environment Variables** (Optional but recommended):
    *   If you have any API keys or secrets (like Appwrite endpoint/project ID), you can add them here.
    *   *Note: Since this is a client-side web app, these are usually baked into the build or loaded at runtime. For this Docker setup, `environment.dart` uses hardcoded values or `const` variables, so you might not need to set them here unless you change how configuration is loaded.*
6.  **Deploy**:
    *   Click **Create Web Service**.

## What Happens Next?

1.  Render will pull your code from GitHub.
2.  It will detect the `Dockerfile` in the root directory.
3.  It will start building the Docker image:
    *   It downloads Flutter.
    *   It runs `flutter build web --release`.
    *   It sets up Nginx to serve the files.
4.  Once the build is complete, it will deploy the service and provide you with a URL (e.g., `https://gulfon-expense-manager.onrender.com`).

## Troubleshooting

*   **Build Failures**: Check the "Logs" tab in Render. Common issues include missing dependencies in the Dockerfile (we've added standard ones) or compilation errors.
*   **404 Errors**: If you refresh a page and get a 404, it's because Nginx needs to be configured to redirect all requests to `index.html` (Single Page Application routing).
    *   *The current Dockerfile uses default Nginx config.*
    *   *If you encounter this, we may need to add a custom `nginx.conf`.*

### Custom Nginx Configuration (If needed for routing)

If you find that navigating directly to a URL like `/dashboard` fails, create a file named `nginx.conf` in your project root with the following content:

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

And update the `Dockerfile` (Stage 2) to copy it:

```dockerfile
# ... (Stage 1 remains the same)

# Stage 2: Serve the App with Nginx
FROM nginx:alpine

# Copy the build output
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```
