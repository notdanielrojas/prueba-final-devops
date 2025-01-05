# Usa una imagen base de Node.js
FROM node:16-alpine

# Crea el directorio de trabajo y establece permisos
WORKDIR /home/node/app
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# Copia el archivo package.json y package-lock.json
COPY --chown=node:node package*.json ./

# Cambia al usuario node
USER node

# Ejecuta la instalación de dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY --chown=node:node . .

# Especifica el comando de inicio
CMD ["npm", "start"]
