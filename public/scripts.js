/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 */

let isShowPlayers = false;
let isShowAcByAll = false;
let isShowHaving = false;
let isShowGroupBy = false;
let isShowNestedAgg = false;
let c = 2;

// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');
    const loadingGifElem = document.getElementById('loadingGif');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Hide the loading GIF once the response is received.
    loadingGifElem.style.display = 'none';
    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
    .then((text) => {
        statusElem.textContent = text;
    })
    .catch((error) => {
        statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
    });
}

function makeTableRows(resData, tableBody) {
	resData.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// fetch players table
async function fetchAndDisplayPlayers() {
    const tableElement = document.getElementById('allPlayers');
    const tableBody = document.getElementById('tbodyAllPlayers');

    const response = await fetch('/players', {
        method: 'GET'
    });
    const responseData = await response.json();
    const playersContent = responseData.data;

    if (tableBody) {
        tableBody.innerHTML = '';
    }

    makeTableRows(playersContent, tableBody);

}

function showHidePlayers() {
    const playerSection = document.getElementById('playerSection');

	if (isShowPlayers) {
		playerSection.classList.add('hide');
        document.getElementById("viewPlayersTable").innerHTML = 'View All Players';
	} else {
		document.getElementById("viewPlayersTable").innerHTML = 'Hide All Players';
		playerSection.classList.remove('hide');
		fetchAndDisplayPlayers();
	}
	isShowPlayers = !isShowPlayers;
}

// for INSERT on PlayerHas
async function insertPlayer(e) {
  e.preventDefault();

  const form = document.getElementById("insertPlayer");
  const formData = new FormData(form);

  const response = await fetch('/insert-player', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json'
      },
      body: JSON.stringify(Object.fromEntries(formData))
  });

  const responseData = await response.json();
  const messageElement = document.getElementById('insertResultMsg');

  if (responseData.success) {
      messageElement.textContent = "Player inserted successfully!";
      form.reset();
      fetchTableData();
  } else {
      messageElement.textContent = "Error inserting Player!";
  }
}

// for UPDATE on PlayerHas
async function updatePlayerInfo(e) {
  e.preventDefault();

  const form = document.getElementById("updatePlayerEmailXp");
  const formData = new FormData(form);

  const response = await fetch('/update-player', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json'
      },
      body: JSON.stringify(Object.fromEntries(formData))
  });

  const responseData = await response.json();
  const messageElement = document.getElementById('updateResultMsg');

  if (responseData.success) {
      messageElement.textContent = "Player updated successfully!";
      form.reset();
      fetchTableData();
  } else {
      messageElement.textContent = "Error updating Player!";
  }
}

// for DELETE on PlayerHas
async function deletePlayer(e) {
    e.preventDefault();

    const usernameValue = document.getElementById('delUsername').value;

    const response = await fetch('/delete-player', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username: usernameValue,
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('delPlayerResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Player deleted successfully!";
        document.getElementById('delPlayer').reset();
        fetchTableData();
    } else {
        messageElement.textContent = "Error deleting player!";
    }
}

// for DIVISION on Achievement
async function viewAcByAll() {
	const tableElement = document.getElementById('divAchievement');
    const tableBody = document.getElementById('tbodyDivAchievement');

	// hide table
    if (isShowAcByAll) {
        tableElement.classList.add("hide");
        document.getElementById("divAchievementBtn").innerHTML = 'View Achievements achieved by all players';

    //fetch and show table
    } else {
        document.getElementById("divAchievementBtn").innerHTML = 'Hide Achievements achieved by all players';

        const response = await fetch('/divAchievement', {
            method: 'GET'
        });

        const responseData = await response.json();
        const acByAll = responseData.data;

        if (tableBody) {
            tableBody.innerHTML = '';
        }

        makeTableRows(acByAll, tableBody);
        tableElement.classList.remove("hide");
    }

    isShowAcByAll = !isShowAcByAll;
}

// for PROJECTION on Mob1
async function projMob(e) {
  e.preventDefault();
  const tableElement = document.getElementById('showProjMob');
  const tableBody = document.getElementById('tbodyProjMob');
  const tableTr = document.getElementById('trProjMob');
  const form = document.getElementById('formProjMob');
  const hideBtn = document.getElementById('hideMobBtn');
  const formData = new FormData(form);

  const arrData = formData.getAll('atts');
  // handle user not selecting any checkbox
    if (arrData.length == 0) {
      alert('Please select at least 1 attribute');
      return;
    }
  const strData = arrData.join(",");

  // reset column names
  if (tableTr) {
     tableTr.innerHTML = "";
  }

  // get column names
  arrData.map((att) => {
    let trElem = document.createElement('th');
    trElem.innerHTML = att;
    tableTr.appendChild(trElem);
  });

  const response = await fetch(`/projMob?atts=${strData}`, {
    method: 'GET',
  });

  const responseData = await response.json();
  const projMob = responseData.data;

  if (tableBody) {
    tableBody.innerHTML = '';
  }

  makeTableRows(projMob, tableBody);
  tableElement.classList.remove('hide');
  hideBtn.classList.remove('hide');
}

function closeProjMobTable() {
	const tableElement = document.getElementById('showProjMob');
	const hideBtn = document.getElementById('hideMobBtn');
	tableElement.classList.add('hide');
	hideBtn.classList.add('hide');
}

// for AGGREGATION with HAVING on Saved
async function viewHaving() {
	const tableElement = document.getElementById('having');
    const tableBody = document.getElementById('tbodyHaving');

	// hide table
    if (isShowHaving) {
        tableElement.classList.add("hide");
        document.getElementById("havBtn").innerHTML = 'View Popular Worlds';

    //fetch and show table
    } else {
        document.getElementById("havBtn").innerHTML = 'Hide Popular Worlds';

        const response = await fetch('/havingSaved', {
            method: 'GET'
        });

        const responseData = await response.json();
        const acByAll = responseData.data;

        if (tableBody) {
            tableBody.innerHTML = '';
        }

        makeTableRows(acByAll, tableBody);
        tableElement.classList.remove("hide");
    }

    isShowHaving = !isShowHaving;
}

// for AGGREGATION with GROUP BY on Achieve
async function viewGroupBy() {
    const tableElement = document.getElementById('groupBy');
    const tableBody = document.getElementById('tbodyGroupBy');

    // hide table
    if (isShowGroupBy) {
        tableElement.classList.add("hide");
        document.getElementById("groupBtn").innerHTML = 'View';

        //fetch and show table
    } else {
        document.getElementById("groupBtn").innerHTML = 'Hide';

        const response = await fetch('/groupByAchieve', {
            method: 'GET'
        });

        const responseData = await response.json();
        const acByAll = responseData.data;

        if (tableBody) {
            tableBody.innerHTML = '';
        }

        makeTableRows(acByAll, tableBody);
        tableElement.classList.remove("hide");
    }

    isShowGroupBy = !isShowGroupBy;
}

// for NESTED AGGREGATION with GROUP BY on Achieve
async function nestedProgress() {
    const tableElement = document.getElementById('nestedAggTable');
    const tableBody = document.getElementById('tbodyNestAgg');

    if (isShowNestedAgg) {
        tableElement.classList.add('hide');
        document.getElementById("nestedAggBtn").innerHTML = 'View Average Progress';
    } else {
        document.getElementById("nestedAggBtn").innerHTML = 'Hide Average Progress';

        const response = await fetch('/nested-agg-avg', {
            method: 'GET'
        });
        const responseData = await response.json();
        const nestedContent = responseData.data;

        if (tableBody) tableBody.innerHTML = '';

        nestedContent.forEach(row => {
            const newRow = tableBody.insertRow();
            row.forEach((cellVal) => {
                const cell = newRow.insertCell();
                cell.textContent = cellVal;
            });
        });
        tableElement.classList.remove('hide');
    }
    isShowNestedAgg = !isShowNestedAgg;
}

// for JOIN on Player and Achieve
async function joinPlayer(e) {
    e.preventDefault();

    const usernameValue = document.getElementById('joinUsername').value;
    const tableElement = document.getElementById('tableJoinTable');
    const tableBody = document.getElementById('tbodyJoinResult');

    const response = await fetch(`/join-player-achieve?username=${encodeURIComponent(usernameValue)}`, {
        method: 'GET'
    });
    const responseData = await response.json();
    const joinsContent = responseData.data;

    tableBody.innerHTML = '';

    joinsContent.forEach(row => {
        const newRow = tableBody.insertRow();
        row.forEach((cellVal) => {
            const cell = newRow.insertCell();
            cell.textContent = cellVal;
        });
    });

    tableElement.classList.remove('hide');
}

function addCondition() {
    const container = document.getElementById('selectionContainer');

    container.appendChild(document.createElement("br"));

    const op = document.createElement("select");
    op.name = "operation";
    op.id = "operation" + c;
    op.options[op.options.length] = new Option('AND', 'AND');
    op.options[op.options.length] = new Option('OR', 'OR');
    container.appendChild(op);

    container.appendChild(document.createElement("br"));

    const label = document.createElement("label");
    label.for = "attribute" + c;
    label.text = "Choose Attribute " + c + ":";
    container.appendChild(label);

    container.appendChild(document.createElement("br"));

    const select = document.createElement("select");
    select.name = "attribute";
    select.id = "attribute" + c;
    select.options[select.options.length] = new Option('IP Address', 'IPaddress');
    select.options[select.options.length] = new Option('Server Name', 'sname');
    select.options[select.options.length] = new Option('Player Capacity', 'player_capacity');
    container.appendChild(select);

    const input = document.createElement("input");
    input.type = "text";
    input.id = "condition" + c;
    input.name = "condition";
    input.placeholder = "What should this attribute be equal to?";
    input.maxLength = "255";
    input.required = true;
    container.appendChild(input);

    container.appendChild(document.createElement("br"));
    c++;
}

// SELECTION on Server
async function selectServer(e) {
  e.preventDefault();

  const tableElement = document.getElementById('selection');
  const tableBody = document.getElementById('tbodySelection');

  const form = document.getElementById('selectionForm');
  const formData = new FormData(form);

  const attsArr = formData.getAll('attribute');
  const condsArr = formData.getAll('condition');
  const opsArr = formData.getAll('operation');

  const attsData = attsArr.join(",");
  const condsData = condsArr.join(",");
  const opsData = opsArr.join(",");

const response = await fetch(`/selectServer?atts=${attsData}&conds=${condsData}&ops=${opsData}`, {
  method: 'GET',
});

  const responseData = await response.json();
  const selectServer = responseData.data;

  if (tableBody) {
      tableBody.innerHTML = '';
  }

  makeTableRows(selectServer, tableBody);
  tableElement.classList.remove('hide');
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
window.onload = function() {
    checkDbConnection();
    document.getElementById("viewPlayersTable").addEventListener("click", showHidePlayers);
    document.getElementById("insertPlayer").addEventListener("submit", insertPlayer);
    document.getElementById("updatePlayerEmailXp").addEventListener("submit", updatePlayerInfo);
    document.getElementById("divAchievementBtn").addEventListener("click", viewAcByAll);
    document.getElementById("formProjMob").addEventListener("submit", projMob);
    document.getElementById('hideMobBtn').addEventListener("click", closeProjMobTable);
    document.getElementById("delPlayer").addEventListener("submit", deletePlayer);
    document.getElementById("havBtn").addEventListener("click", viewHaving);
    document.getElementById("groupBtn").addEventListener("click", viewGroupBy);
    document.getElementById('nestedAggBtn').addEventListener("click", nestedProgress);
    document.getElementById('joinPlayerAndAchieve').addEventListener("submit", joinPlayer);
    document.getElementById("addCondition").addEventListener("click", function(e) {
        e.preventDefault();
        addCondition();
    });
    document.getElementById("selectionForm").addEventListener("submit", selectServer);
};

// General function to refresh the displayed table data.
function fetchTableData() {
    fetchAndDisplayPlayers();
}
