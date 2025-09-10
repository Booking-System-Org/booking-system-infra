import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { join } from 'path';

export default new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT) || 5432,
    username: process.env.DB_USER,
    database: process.env.DB_NAME,
    entities: [],
    migrations: [join(__dirname, 'migrations/*.ts')],
    logging: true,
    migrationsRun: false,
    synchronize: false,
});

