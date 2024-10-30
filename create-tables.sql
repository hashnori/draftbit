-- Create example_table as before
CREATE TABLE example_table (
  id SERIAL PRIMARY KEY,
  some_int INT,
  some_text TEXT
);

INSERT INTO example_table (some_int, some_text) VALUES (123, 'hello');

-- Correct table creation and insertion for updateInputs
CREATE TABLE "updateInputs" (
  id SERIAL PRIMARY KEY,
  top TEXT,
  "left" TEXT,
  "right" TEXT,
  bottom TEXT,
  "outerTop" TEXT,
  outerleft TEXT,
  "outerRight" TEXT,
  outerbottom TEXT


);

-- Insert initial data to ensure there's a row to update
INSERT INTO "updateInputs" (top, "left", "right", bottom,"outerTop",outerleft,"outerRight",outerbottom)
VALUES ('auto', '24px', '24px', 'auto','auto', '24px', '24px', 'auto');
