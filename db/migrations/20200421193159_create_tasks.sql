-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name CHAR(255),
  done BOOLEAN,
  creation_date DATETIME
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE tasks;
