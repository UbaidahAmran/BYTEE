# BYTEE — Hostel Reservation System

BYTEE is a web-based hostel (residential college) reservation system built with **Java Servlets, JSP and MySQL**. Students can browse colleges, book a bed through a step-by-step wizard, see their roommates and file complaints. Admins manage rooms, students, reservations and announcements from a dashboard.

## Features

**Students**
- Register with a profile picture, log in, reset password
- Browse residential colleges and their details
- Book a bed in 3 steps: college → block → bed
- View and cancel reservations, see roommates and their public profiles
- File complaints (with image upload) and read announcements

**Admins**
- Dashboard with occupancy overview
- Manage rooms, students, reservations and announcements

## Tech stack

| Layer      | Technology                                  |
|------------|---------------------------------------------|
| Backend    | Java Servlets (`javax.servlet`, Servlet 4.0) |
| Frontend   | JSP, HTML, CSS                              |
| Database   | MySQL 8.0                                   |
| Server     | Apache Tomcat 9                             |
| IDE (used) | Eclipse IDE for Enterprise Java             |

> Tomcat 10+ will **not** work as-is, because the code uses `javax.servlet` (Tomcat 10 switched to `jakarta.servlet`).

## Project structure

```
BYTEE/
├── bytee_db.sql              # MySQL dump (schema + sample colleges/rooms + demo accounts)
└── src/main/
    ├── java/com/bytee/
    │   ├── controller/       # Controller (login/logout/dashboards), AuthFilter
    │   ├── db/               # DBConnection, DBTest
    │   └── servlet/          # Booking, profile, complaint & admin servlets
    └── webapp/
        ├── *.jsp             # All pages (entry point: index.jsp)
        ├── images/
        └── WEB-INF/web.xml
```

## Prerequisites

- **JDK 8 or newer** (JDK 11/17 recommended)
- **Apache Tomcat 9.x** — https://tomcat.apache.org/download-90.cgi
- **MySQL Server 8.0** (+ MySQL Workbench, optional)
- **MySQL Connector/J** (`mysql-connector-j-8.x.jar`) — https://dev.mysql.com/downloads/connector/j/
- Eclipse IDE for Enterprise Java (only if you want to run from source)

## 1. Set up the database

Open a MySQL shell (or Workbench) as `root` and run:

```sql
CREATE DATABASE bytee_db;
CREATE USER 'bytee_user'@'localhost' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON bytee_db.* TO 'bytee_user'@'localhost';
FLUSH PRIVILEGES;
```

Then import the dump:

```bash
mysql -u root -p bytee_db < bytee_db.sql
```

(In Workbench: **Server → Data Import → Import from Self-Contained File**, target schema `bytee_db`.)

## 2. Configure the database connection

Edit `src/main/java/com/bytee/db/DBConnection.java` so it matches your MySQL user:

```java
private static final String URL = "jdbc:mysql://localhost:3306/bytee_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USER = "bytee_user";
private static final String PASSWORD = "CHANGE_ME"; // put your MySQL password here
```

You can check the connection by running `com.bytee.db.DBTest` as a Java application (update its credentials too).

## 3. Create the upload folder

Profile pictures and complaint images are saved outside the project, in:

```
C:\bytee_uploads
```

Create this folder before running. On macOS/Linux, change `UPLOAD_DIR` in `RegisterServlet`, `ProfileServlet`, `ComplaintServlet` and `ImageServlet` to a path that exists on your machine (e.g. `/home/you/bytee_uploads`).

## 4. Add the MySQL driver

Copy `mysql-connector-j-8.x.jar` into **one** of:

- `<TOMCAT_HOME>/lib/` (recommended), or
- `src/main/webapp/WEB-INF/lib/`

## 5. Run the application

### Run from source in Eclipse

1. **File → New → Dynamic Web Project**, name it `ByteeTest`, target runtime **Apache Tomcat v9.0**.
2. Copy `src/main/java` and `src/main/webapp` from this repo into the project (replace the generated folders).
3. Make sure the MySQL connector JAR is on the build path (step 4).
4. Right-click the project → **Run As → Run on Server** → choose Tomcat 9.
5. Open http://localhost:8080/ByteeTest/

To deploy without Eclipse: right-click the project → **Export → WAR file**, copy the `.war` into `<TOMCAT_HOME>/webapps/` and start Tomcat (`bin/startup.bat` on Windows, `bin/startup.sh` on macOS/Linux).

## 6. Log in

Login uses the **matric number** and password. The database comes with two demo accounts:

| Role    | Matric number | Password    |
|---------|---------------|-------------|
| Admin   | `STAFF001`    | `admin123`  |
| Student | `123457`      | `456123`    |

You can also register a new student account from the login page.

## Troubleshooting

| Problem | Fix |
|---|---|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Connector/J JAR is missing — see step 4, then restart Tomcat |
| `Access denied for user 'bytee_user'` | Credentials in `DBConnection.java` don't match your MySQL user |
| `Unknown database 'bytee_db'` | Create the database and import `bytee_db.sql` (step 1) |
| Profile/complaint images don't show | `C:\bytee_uploads` doesn't exist or doesn't contain the files |
| 404 on every page | Check the URL context path matches the deployed name (`/ByteeTest/`) |
| `jakarta.servlet` / `javax.servlet` errors | Use Tomcat 9, not Tomcat 10+ |

## Notes

This is an academic project. Passwords are stored in plain text and credentials are hard-coded, so it is not meant for production use.
