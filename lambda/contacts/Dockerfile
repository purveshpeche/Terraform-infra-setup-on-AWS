FROM public.ecr.aws/lambda/nodejs:18

# Copy function code
COPY index.js ${LAMBDA_TASK_ROOT}

# Install dependencies
COPY package*.json ./
RUN npm install --production

# Set the CMD to your handler
CMD [ "index.handler" ]
