const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints
router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('connected');
    } else {
        res.send('unable to connect');
    }
});

// fetch players table
router.get('/players', async (req, res) => {
    const tableContent = await appService.fetchPlayersFromDb();
    res.json({ data: tableContent });
});

// for INSERT on PlayerHas
router.post("/insert-player", async (req, res) => {
  //    const { username, user_credentials, xp, email, skin, iid } = req.body;
      const username = req.body.username;
      const user_credentials = req.body.userCredentials;
      const xp = req.body.xp;
      const email = req.body.email;
      const skin = req.body.skin;
      const iid = req.body.iid;

      const insertResult = await appService.insertPlayer(username, user_credentials, xp, email, skin, iid);
      if (insertResult) {
          res.json({ success: true });
      } else {
          res.status(500).json({ success: false });
      }
  });

// for UPDATE on PlayerHas
router.post("/update-player", async (req, res) => {
    const { username, email, xp, skin } = req.body;
    const updateResult = await appService.updatePlayerTable(username, email, xp, skin);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

// for DELETE on PlayerHas
router.post("/delete-player", async (req, res) => {
    const { username } = req.body;
    const deleteResult = await appService.deletePlayer(username);
    if (deleteResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

// for DIVISION on Achievement
router.get('/divAchievement', async (req, res) => {
    const tableContent = await appService.divAchievement();
    res.json({data: tableContent});
});

// for PROJECTION on Mob1
router.get('/projMob', async (req, res) => {
    const params = req.query.atts;
    const tableContent = await appService.projMob(params);
    res.json({ data: tableContent });
});

// for SELECTION on Server
router.get('/selectServer', async (req, res) => {
	const atts = req.query.atts;
	const conds = req.query.conds;
	const ops = req.query.ops;
//    const clauses = req.query.condition;
    const tableContent = await appService.selectServer(atts, conds, ops);
    res.json({ data: tableContent });
});

// for AGGREGATION with HAVING on Saved
router.get('/havingSaved', async (req, res) => {
    const tableContent = await appService.havingSaved();
    res.json({data: tableContent});
});

// for AGGREGATION with GROUP BY on Achieve
router.get('/groupByAchieve', async (req, res) => {
    const tableContent = await appService.groupByAchieve();
    res.json({data: tableContent});
});

// for NESTED AGGREGATION with GROUP BY on Achieve
router.get('/nested-agg-avg', async (req, res) => {
    const nestedResult = await appService.nestedAggAvgProgress();
    res.json({ data: nestedResult });
});

// for JOIN on Player and Achieve
router.get('/join-player-achieve', async (req, res) => {
    const { username } = req.query;
    const joinResult = await appService.joinPlayerAchieve(username);
    res.json({ data: joinResult });
});


module.exports = router;
