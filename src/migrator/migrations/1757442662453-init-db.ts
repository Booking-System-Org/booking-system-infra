import { id, timestampts } from '../utils';
import { TableIndex, MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class InitDb1757442662453 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
      await queryRunner.createTable(
        new Table({
          name: 'restaurants',
          columns: [
            id,
            {
              name: 'name',
              type: 'text',
              isNullable: false,
            },
            {
              name: 'address',
              type: 'text',
              isNullable: false,
            },
            ...timestampts,
          ],
        }),
        true,
      );

      await queryRunner.createTable(
        new Table({
          name: 'bookings',
          columns: [
            id,
            {
              name: 'restaurant_id',
              type: 'uuid',
              isNullable: false,
            },
            {
              name: 'guest_count',
              type: 'integer',
              isNullable: false,
            },
            {
              name: 'booking_date',
              type: 'timestamptz',
              precision: 3,
              isNullable: false,
            },
            {
              name: 'status',
              type: 'enum',
              enum: ['CREATED', 'CHECKING_AVAILABILITY', 'CONFIRMED', 'REJECTED'],
              default: "'CREATED'",
              isNullable: false,
            },
            ...timestampts,
          ],
        }),
        true,
      );

      await queryRunner.createForeignKey(
        'bookings',
        new TableForeignKey({
          columnNames: ['restaurant_id'],
          referencedTableName: 'restaurants',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );

      await queryRunner.createIndex('bookings', new TableIndex({ columnNames: ['restaurant_id'], name: 'idx_bookings_restaurant_id' }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
      await queryRunner.dropIndex('bookings', 'idx_bookings_restaurant_id');
      await queryRunner.dropTable('bookings');
      await queryRunner.dropTable('restaurants');
    }

}
