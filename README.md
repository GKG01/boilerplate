# Laravel React Boilerplate

A reusable starting point for Laravel 13, React 19, Inertia 3, TypeScript, and Tailwind CSS 4. It includes authentication, two-factor authentication, passkeys, a dashboard, and account settings. Docker Compose runs PHP-FPM, Nginx, and MySQL 8.4.

## Start a new project

Copy this directory to a new project folder. The copy has no Git history, local `.env`, installed dependencies, or generated files.

Before starting the copy, replace the boilerplate identity with your project's own values:

- In `docker-compose.yaml`, change the Compose project name, `APP_NAME`, database name and user, volume names, container names, and default host ports. This keeps multiple projects from sharing container names, volumes, or ports.
- In `Dockerfile`, change `VITE_APP_NAME`. In `.env.example`, change `APP_NAME`, `DB_DATABASE`, `DB_USERNAME`, and `DB_PORT` to match Compose.
- In `composer.json`, change the package name and description if you want project-specific package metadata. Refresh `composer.lock` after changing Composer dependencies or metadata.
- Replace this README's title and instructions with those for your project. Change any starter links or branding in `resources/js` as needed.

Then create an ignored `.env` from `.env.example`, set distinct strong `MYSQL_PASSWORD` and `MYSQL_ROOT_PASSWORD` values, and start Docker:

```bash
cp .env.example .env
# Edit .env and set MYSQL_PASSWORD and MYSQL_ROOT_PASSWORD.
docker compose up --build -d
docker compose ps
```

The boilerplate defaults bind the site to `127.0.0.1:80` (open `http://localhost`) and MySQL to `127.0.0.1:3308`. The host-side `.env` uses port 3308; containers connect to `db:3306`. Only one project can use localhost port 80 at a time. If you change `BOILERPLATE_PORT` or `BOILERPLATE_DB_PORT`, keep `APP_URL` and host-side `DB_PORT` in `.env` aligned. Docker generates and persists its own application key and runs migrations on startup.

Use `docker compose down` to stop the project without deleting data. `docker compose down --volumes` permanently deletes its database, application key, and uploaded files.

## Local development

For host-side Laravel and Vite commands, install PHP, Composer, and Node.js, start the MySQL container, and configure `.env` for the host. Then run:

```bash
composer install
php artisan key:generate
npm ci
php artisan migrate
composer run dev
```

The development server uses `http://localhost:8000` by default. Run `php artisan test`, `npm run check`, and `npm run types:check` for the included checks.

## Project layout

- `routes/web.php`: application routes.
- `resources/js/pages` and `resources/js/components`: React pages and shared UI.
- `app/Models` and `database/migrations`: application data.
- `Dockerfile`, `docker-compose.yaml`, and `docker/`: container setup.

Based on the [Laravel React starter kit](https://github.com/laravel/react-starter-kit) at commit `0c94c26ff7711255e7a92996eedf97689240e51c`. The upstream MIT license is retained.
