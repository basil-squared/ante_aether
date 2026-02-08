import subprocess
import sys
from pathlib import Path

def main():
    # Determine paths relative to this script
    script_dir = Path(__file__).resolve().parent
    root_dir = script_dir.parent
    
    # Define paths relative to root
    ss_path = root_dir / "spritesheets"
    export_base = root_dir / "exports" / "individual"

    # Verify spritesheets directory exists
    if not ss_path.exists():
        print(f"ERROR: Spritesheets directory not found at {ss_path}")
        print("Please create the directory and add your .aseprite files there.")
        sys.exit(1)

    # Verify Aseprite is available
    try:
        subprocess.run(
            ["aseprite", "--version"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        print(
            "ERROR: Aseprite not found. Please install Aseprite and ensure it's in your PATH"
        )
        sys.exit(1)

    # Get Aseprite files
    filelist = list(ss_path.glob("*.aseprite"))
    if not filelist:
        print(f"ERROR: No .aseprite files found in {ss_path}")
        sys.exit(1)

    print(f"Found {len(filelist)} files to process.")

    # Iterate through files
    for i, filepath in enumerate(filelist, 1):
        sprite_name = filepath.stem
        print(f"[{i}/{len(filelist)}] Processing: {sprite_name}")

        for scale in [1, 2]:
            # Create sprite-specific output directory
            output_dir = export_base / sprite_name / f"{scale}x"
            output_dir.mkdir(parents=True, exist_ok=True)

            # Build Aseprite command
            cmd = [
                "aseprite",
                "-b",
                str(filepath),  # Source document
                "--save-as",
                str(output_dir / "frame_{frame04}.png"),  # Output pattern with 4 digits
            ]

            if scale > 1:
                cmd.insert(3, "--scale")
                cmd.insert(4, str(scale))

            # print(f"Exporting to: {output_dir}")  # Debug output (commented out to reduce noise)

            try:
                result = subprocess.run(cmd, capture_output=True, text=True)

                if result.returncode != 0:
                    print(f"\nERROR processing {sprite_name} at {scale}x:")
                    print(result.stderr)

            except Exception as e:
                print(f"\nEXCEPTION processing {filepath}: {str(e)}")

    # Verify exports
    exported_files = list(export_base.rglob("*.png"))
    if not exported_files:
        print("\nERROR: No files exported. Please check:")
        print("1. Your Aseprite files contain frames")
        print("2. Try running this command manually:")
        print(
            f"aseprite -b {ss_path}/example.aseprite --save-as {export_base}/example/1x/frame_{{frame4}}.png"
        )
    else:
        print(f"\nSuccess! Exported {len(exported_files)} frames")
        print(f"Files organized in: {export_base}")


if __name__ == "__main__":
    main()