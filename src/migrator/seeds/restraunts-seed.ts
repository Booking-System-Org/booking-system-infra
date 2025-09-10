import 'reflect-metadata';
import dataSource from '../data-source';

const restaurants = [
    {
        name: 'Итальянская кухня',
        address: 'Москва, ул. Пушкина, 10'
    },
    {
        name: 'Суши-бар Токио', 
        address: 'Москва, пр. Ленина, 25'
    },
    {
        name: 'Французский ресторан Ла Скала',
        address: 'Москва, ул. Гоголя, 5'
    }
];

async function seedRestaurants() {
    try {
        await dataSource.initialize();
        console.log('Connection to DB established');

        const existingCount = await dataSource.query('SELECT COUNT(*) FROM restaurants');
        if (parseInt(existingCount[0].count) > 0) {
            console.log('Restaurants already exist, skipping seeding');
            return;
        }

        for (const restaurant of restaurants) {
            await dataSource.query(
                'INSERT INTO restaurants (id, name, address, created_at, updated_at) VALUES (uuid_generate_v4(), $1, $2, now(), now())',
                [restaurant.name, restaurant.address]
            );
        }

        console.log(`Added ${restaurants.length} restaurants`);
    } catch (error) {
        console.error('Error while seeding data:', error);
        process.exit(1);
    } finally {
        await dataSource.destroy();
        process.exit(0);
    }
}

seedRestaurants();
