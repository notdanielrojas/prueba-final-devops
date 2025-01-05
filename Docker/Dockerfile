# Usa una versión más reciente y segura de Node.js
FROM node:18-alpine

# Crea el directorio de trabajo y establece permisos
WORKDIR /home/node/app
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# Copia el archivo package.json y package-lock.json
COPY --chown=node:node package*.json ./ 

# Cambia al usuario node para reducir el riesgo de ejecutar como root
USER node

# Instala las dependencias en modo de producción
RUN npm ci --only=production

# Copia el resto de los archivos de la aplicación
COPY --chown=node:node . .

# Realiza un escaneo de seguridad con npm audit (opcional pero recomendado)
RUN npm audit --production

# Especifica el comando de inicio
CMD ["npm", "start"]
