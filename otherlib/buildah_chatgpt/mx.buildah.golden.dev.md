
# Framework Overview
1. **Goal**: Build a framework for creating "golden images" using Buildah and Kaniko. These images will serve as base templates for your container infrastructure.
2. **Components**:
   - **Detect the OS**: Identify which OS the script is working with (Alpine, Ubuntu, etc.) and handle unsupported ones gracefully.
   - **Create the Golden Image**: The script will create a base image by:
     - Adding a user with sudo privileges.
     - Creating a predefined directory structure for workspace.
   - **No Code Duplication**: The process should be flexible and reusable across different OS base images without duplicating code.




# Workflow

**1. Define the Workflow**:
   - Create a container image starting from the base OS image (e.g., Alpine, Ubuntu).
   - Add necessary configurations (e.g., user creation, directory structure).

**2. Workflow Steps**:
   - **OS Detection**:
     - The `detect_os` function checks which OS the image is based on.
     - If the OS is unsupported, the script exits after logging the error.
   - **User Creation**:
     - Create a user with sudo privileges (via `create_sudo_user`).
   - **Directory Setup**:
     - Set up a workspace directory structure (`create_user_directories`).
   - **Buildah/Container Creation**:
     - Use Buildah commands (or a Dockerfile-based approach) to build the image.
     - Optionally, use Kaniko for remote building and pushing.



# Features

| ID | Name                          | Description                                      |
|----|-------------------------------|--------------------------------------------------|
| F1 | Detect Operating System        | Identify the OS (Alpine, Ubuntu, etc.) used in the image |
| F2 | Create User                    | Add a sudo user to the image                      |
| F3 | Create Directories             | Set up workspace directories inside the user's home |

# Objectives

| ID | Name                          | Related Feature (ID) | Description                                         |
|----|-------------------------------|----------------------|-----------------------------------------------------|
| O1 | Detect Supported OS            | F1                   | Ensure the OS is supported for golden image creation |
| O2 | Create Sudo User               | F2                   | Create a user with sudo privileges in the image     |
| O3 | Create Workspace Directory     | F3                   | Set up a basic workspace directory structure       |


# Next Steps
1. **Testing and Validation**:
   - Test the script with different OS base images (Alpine, Ubuntu, etc.).
   - Ensure that the user creation and directory setup are working as expected.

2. **Kaniko Integration** (optional):
   - Add a Kaniko step if you need to push the images to a remote OCI-compliant registry.

3. **Scalability**:
   - Add additional requirements as needed without duplicating code.



# Todo






### **Step 1: Prepare the Environment**

Before testing, ensure that all the required tools and scripts are in place:


2. **Prepare the necessary files and scripts**.
   - Place the following scripts in the same directory:
     - `buildah.golden.dev.sh` (Main script for creating golden images).
     - `buildah_golden_image_helpers.sh` (Auxiliary helper functions).
     - `log_helper.sh` (Logging helper).

3. **Set executable permissions** for the scripts:

   ```bash
   chmod +x buildah.golden.dev.sh
   chmod +x buildah_golden_image_helpers.sh
   chmod +x log_helper.sh
   ```

---

### **Step 2: Run the Image Creation Test**

Now, let’s execute the script to create a golden image for development. 

1. **Execute the `buildah.golden.dev.sh` script**:
   
   - Open the terminal in the directory where the scripts are located.
   - Run the main script:

     ```bash
     ./buildah.golden.dev.sh
     ```

   This should trigger the function `luc_buildah_image_golden_dev_create()`, which will:
   - Detect the operating system.
   - Create a sudo user.
   - Set up directories for the user in the home folder.
   - Create a basic golden image.

   If everything works, you should see output similar to:

   ```
   Purpose: buildah create a golden image for Dev usage
   Usage: luc_buildah_image_golden_dev_create ...
   Detected OS: ubuntu
   Creating sudo user goldenuser...
   Directory structure for goldenuser created.
   Golden image build complete.
   ```

2. **Check for errors**:
   - If the OS is unsupported, the script will log the error and exit:
     
     ```
     [ERROR] Unsupported OS detected. Exiting process.
     ```

3. **Verify the golden image**:
   - After the script runs, you can check if the image was successfully created by using Buildah to list the available images:

     ```bash
     buildah images
     ```

   This should list the golden image created, along with its layers and other metadata.

---

### **Step 3: Validate the Image Creation**

1. **Inspect the image**:
   - Once the image is created, use the following command to inspect the image’s details (including the layers, user, etc.):

     ```bash
     buildah inspect <image-name>
     ```

   Replace `<image-name>` with the actual image name generated. This will show the image details, including user information and directory structure.

2. **Test the created image** by running it:
   - You can test the image by creating a container from it and checking that the user and directories were correctly created.

     ```bash
     podman run -it <image-name> /bin/bash
     ```

   This should open a terminal inside the container, where you can verify:
   - The `goldenuser` exists and can use `sudo`.
   - The directory structure (`wkspc`, `projects`, `documents`) is present in `/home/goldenuser`.

---

### **Step 4: Iterate and Adjust**

1. **Adjust the script if needed**:
   - If any issues arise, check the script logs and make adjustments. For example, verify if the correct OS is being detected or if there are errors in user creation.
   - Modify the `luc_buildah_image_golden_dev_create()` function or helper functions as needed.

2. **Test with other base images**:
   - Once you’ve tested with one base image (e.g., `ubuntu`), you can test with other OS images, such as:
     - `almalinux`
     - `alpine`
     - `rockylinux`

   For each OS image, ensure that the script runs without errors and creates the necessary files and configurations.

---

### **Step 5: Clean Up (Optional)**

After testing, you might want to clean up the created images to avoid clutter:

```bash
buildah rm <image-name>
```

This will remove the image after testing.

---

### **Summary of Steps**

1. **Prepare the environment**:
   - Install necessary tools (Buildah, Podman).
   - Set up the scripts and ensure they are executable.
2. **Run the image creation script** (`buildah.golden.dev.sh`).
3. **Validate the image**:
   - Check if the image is listed in Buildah.
   - Inspect and test the created image in a container.
4. **Iterate** and modify the scripts if needed.
5. **Clean up** after testing.

Let me know if you encounter any issues during the process, and I can help troubleshoot further!