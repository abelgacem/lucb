# Reverse port forwarding
Also named reverse SSH tunnel.

```shell
# usage
ssh -f -N -R $lLOCAL_PORT:localhost:$lRSERVER_PORT $lRSERVER_NAME

# example
ssh -f -N -R 9000:localhost:41367 o3u
```



1. **`ssh`**  
   This initiates a Secure Shell (SSH) connection.

2. **`-f`**  
   - Puts the SSH session into the background after authentication.
   - This is useful for running the tunnel without keeping your terminal occupied.

3. **`-N`**  
   - Tells SSH not to execute a remote command. 
   - It is used for port forwarding only (no shell or commands on the remote server).


4. **`-R 9000:localhost:41367`**  
   Sets up the reverse tunnel:
   - **`9000`**: The port on the **remote machine (`o3u`)** that will forward incoming connections.
   - **`localhost:41367`**: The target on your **local machine** where the forwarded traffic will be sent:
     - **`localhost`**: Refers to your local machine (the machine where the SSH command is executed).
     - **`41367`**: The port on your local machine that will receive the traffic.

5. **`o3u`**  
   The remote host to which the SSH connection is made. This could be configured in your `~/.ssh/config.d/config` file with a hostname, user, and other connection details.

---

### **What Happens**
1. An SSH connection is established to `o3u` (a remote machine).
2. Any traffic sent to port **`9000`** on `o3u` is forwarded through the SSH tunnel to port **`41367`** on your **local machine**.
3. The command runs in the background (`-f`), and no interactive session is started (`-N`).

---

### **Use Case Example**
Reverse SSH tunnels like this are often used when:
- A service on your **local machine** (e.g., running on port `41367`) needs to be accessible from the **remote machine** (`o3u`).
- The remote machine doesn’t have direct access to your local network, so you use the tunnel to "reverse" the connection.

For instance:
- If you’re running a web server or application locally on port `41367` and want to make it accessible on `o3u` via port `9000`, this setup achieves that.


# local ssh tunnel
Also named port forwarding.

```shell
# usage
ssh -f -N -L $lLOCAL_PORT:localhost:$lRSERVER_PORT $lRSERVER_NAME

# example
ssh -f -N -L 9000:localhost:4000 o3u

```

1. **`-f`**  
   - Puts the SSH session into the background after authentication.
   - Useful for running the tunnel without keeping your terminal occupied.

2. **`-N`**  
   - Prevents the SSH connection from executing any commands on the remote host.
   - It is used for port forwarding only (no interactive shell).

3. **`-L 9000:localhost:4000`**  
   - Sets up a local port forwarding tunnel:
     - **`9000`**: Port on your local machine that listens for incoming connections.
     - **`localhost:4000`**: The target on the remote machine (`o3u`).
       - **`localhost`** refers to the remote machine (`o3u`).
       - **`4000`** is the port on the remote machine where the service you want to access is running.

4. **`o3u`**  
   - The remote machine to which the SSH connection is established.



---

### **Behavior**
- This command establishes an SSH connection to the remote machine `o3u`.
- It creates a tunnel so that any traffic sent to port **`9000`** on your **local machine** is forwarded through the SSH connection to **port `4000`** on the **remote machine (`o3u`)**.
- Since the `-f` flag runs the SSH session in the background, you can continue using your terminal after setting up the tunnel.

---

### **Use Case Example**
If a Jekyll server is running on the **remote machine (`o3u`)** at `localhost:4000`:
1. Run the command.
2. Open a browser on your **local machine** and navigate to `http://localhost:9000`.
3. You'll see the output of the Jekyll server running on `o3u`.

---
### **Why Use `-f` and `-N`?**
- **`-f`**: Keeps the terminal free by sending the SSH process to the background.
- **`-N`**: Ensures no remote command is executed, making the connection purely for port forwarding.

