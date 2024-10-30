import "dotenv/config";
import { Client } from "pg";
import express from "express";
import waitOn from "wait-on";
import onExit from "signal-exit";
import cors from "cors";

// Add your routes here
const setupApp = (client: Client): express.Application => {
  const app: express.Application = express();

  app.use(cors());
  app.use(express.json());

  app.get("/examples", async (_req, res) => {
    const { rows } = await client.query(`SELECT * FROM example_table`);
    res.json(rows);
  });

  // Select all records from the updateInputs table
  app.get("/updateInputs", async (_req, res) => {
    const { rows } = await client.query(`SELECT * FROM "updateInputs"`);
    res.json(rows[0]);
  });


  // app.post("/updateInputs", async (req, res) => {
  //   try {
  //     const { top, left, center, right, bottom } = req.body;
  //     await client.query(
  //       `UPDATE "updateInputs" SET top = $1, "left" = $2, center = $3, "right" = $4, bottom = $5 WHERE id = 1`,
  //       [top, left, center, right, bottom]
  //     );
  //     res.status(200).send("Inputs updated successfully");
  //   } catch (err) {
  //     console.error(err);
  //     res.status(500).send("Error updating inputs");
  //   }
  // });
  // Route to update the input fields
  app.post("/updateInputs", async (req, res) => {
    try {
      const {
        top,
        left,
        right,
        bottom,
        outerTop,
        outerleft,
        outerRight,
        outerbottom,
      } = req.body;
  
      const query = `
        UPDATE "updateInputs"
        SET 
          top = $1, 
          "left" = $2, 
          "right" = $3, 
          bottom = $4, 
          "outerTop" = $5, 
          outerleft = $6, 
          "outerRight" = $7, 
          outerbottom = $8
        WHERE id = 1 
        RETURNING *;
      `;
  
      const { rows } = await client.query(query, [
        top,
        left,
        right,
        bottom,
        outerTop,
        outerleft,
        outerRight,
        outerbottom,
      ]);
  
      if (rows.length === 0) {
        return res.status(404).send("No record found with id = 1.");
      }
  
      res.json(rows[0]);
    } catch (err) {
      console.error("Error updating inputs:", err);
      res.status(500).send("Error updating inputs");
    }
  });
  

  return app;
};

// Waits for the database to start and connects
const connect = async (): Promise<Client> => {
  console.log("Connecting");
  const resource = `tcp:${process.env.PGHOST}:${process.env.PGPORT}`;
  console.log(`Waiting for ${resource}`);
  await waitOn({ resources: [resource] });
  console.log("Initializing client");
  const client = new Client();
  await client.connect();
  console.log("Connected to database");

  // Ensure the client disconnects on exit
  onExit(async () => {
    console.log("onExit: closing client");
    await client.end();
  });

  return client;
};

const main = async () => {
  const client = await connect();
  const app = setupApp(client);
  const port = parseInt(process.env.SERVER_PORT);
  app.listen(port, () => {
    console.log(
      `Draftbit Coding Challenge is running at http://localhost:${port}/`
    );
  });
};

main();
