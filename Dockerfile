FROM python:3.9

WORKDIR /app
COPY . .

# Install dependencies to support MS SQL ODBC
RUN apt-get update && apt-get install -y \
    curl \
    unixodbc \
    unixodbc-dev

# Add Microsoft SQL ODBC repository (without apt-key)
RUN curl https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/10/prod.list \
    -o /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python requirements
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
