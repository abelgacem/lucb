// Initiate the RS

rsname   = 'mxrs0' 
rsmember = [
  {_id: 0, priority: 2, host: "dock-mongors01:27017"},
  {_id: 1, priority: 1, host: "dock-mongors02:27017"},
  {_id: 2, priority: 1, host: "dock-mongors03:27017"}
]

rsconf = {
  _id:     rsname,
  members: rsmember
}

rs.initiate(rsconf);

// rs.conf();