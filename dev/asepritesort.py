import subprocess
import os
import sys
from pathlib import Path

def main():
    # Determine paths relative to this script
    script_dir = Path(__file__).resolve().parent
    root_dir = script_dir.parent
    
    # Define paths relative to root
    ss_path = root_dir / "dev" / "spritesheets"
    assets_path = root_dir / "assets"

    if not ss_path.exists():
        print(f"ERROR: Spritesheets directory not found at: {ss_path}")
        print("Please create the directory and add your .aseprite files there.")
        sys.exit(1)

    # Ensure output directories exist
    (assets_path / "1x").mkdir(parents=True, exist_ok=True)
    (assets_path / "2x").mkdir(parents=True, exist_ok=True)

    # Check for non-aseprite files
    num_files = sum(1 for x in ss_path.rglob("*.aseprite") if x.is_file())
    if num_files == 0:
        print(f"No .aseprite files found in {ss_path}")
        sys.exit(0)
        
    # Get list of files
    filelist = [f.name for f in ss_path.glob("*.aseprite")]

    print(f"Found {len(filelist)} files to process.")

    # Determine Aseprite executable path
    aseprite_exe = "aseprite" # Default to PATH
    possible_paths = [
        r"C:\Program Files (x86)\Steam\steamapps\common\Aseprite\Aseprite.exe",
        r"C:\Program Files\Steam\steamapps\common\Aseprite\Aseprite.exe"
    ]
    
    for path in possible_paths:
        if os.path.exists(path):
            aseprite_exe = path
            break
    
    print(f"Using Aseprite executable: {aseprite_exe}")

    for i, filename in enumerate(filelist, 1):
        name = filename.replace(".aseprite", "")
        print(f"[{i}/{len(filelist)}] Processing: {name}")

        input_file = ss_path / filename
        output_1x = assets_path / "1x" / f"{name}.png"
        output_2x = assets_path / "2x" / f"{name}.png"
        
        # Helper to run aseprite command
        def run_aseprite(args):
            try:
                subprocess.run(
                    [aseprite_exe] + args,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=False
                )
            except FileNotFoundError:
                print(f"\nERROR: Aseprite not found. Ensure it is in your PATH or installed in default Steam locations.")
                sys.exit(1)

        if filename == "blindatlas.aseprite":
            # Special handling for blindatlas.aseprite with 21 frames per row
            run_aseprite(["-b", "--sheet", str(output_1x), str(input_file), "--sheet-columns", "21"])
            run_aseprite(["-b", "--sheet", str(output_2x), str(input_file), "--sheet-columns", "21", "--scale", "2"])

        elif filename == 'joker_atlas2.aseprite':
             run_aseprite(["-b", "--sheet", str(output_1x), str(input_file), "--sheet-columns", "10"])
             run_aseprite(["-b", "--sheet", str(output_2x), str(input_file), "--sheet-columns", "10", "--scale", "2"])

        elif filename == 'ritualatlas.aseprite':
            run_aseprite(["-b", "--sheet", str(output_1x), str(input_file), "--sheet-columns", "7"])
            run_aseprite(["-b", "--sheet", str(output_2x), str(input_file), "--sheet-columns", "7", "--scale", "2"])

        else:
            # Default export with 4 columns
            run_aseprite(["-b", "--sheet", str(output_1x), str(input_file), "--sheet-columns", "4"])
            run_aseprite(["-b", "--sheet", str(output_2x), str(input_file), "--sheet-columns", "4", "--scale", "2"])
    
    print("\nProcessing complete.")

if __name__ == "__main__":
    main()