psql -U db_italrobot -d systemDB -f drop_view.sql
psql -U db_italrobot -d systemDB -f schema.sql
psql -U db_italrobot -d systemDB -f view.sql
psql -U db_italrobot -d systemDB -f sample_data.sql

