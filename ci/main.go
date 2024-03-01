package main

import (
	"context"
	"fmt"
	"math"
	"math/rand"
	"os"

	"dagger.io/dagger"
)

func main() {
	ctx := context.Background()

	// Initialize Dagger client
	client, err := dagger.Connect(ctx, dagger.WithLogOutput(os.Stderr))
	if err != nil {
		panic(err)
	}
	defer client.Close()

	// Create a cache volume
	cacheVolume := client.CacheVolume("dagger_cache")

	source := client.Container().From("ubuntu:jammy-20240111").
		WithDirectory("./src",
			client.Host().Directory(".", dagger.HostDirectoryOpts{
				Exclude: []string{".github", "clusters"}})).
		WithMountedCache("/dagger_cache", cacheVolume)

	// Prepare the environment, install tools
	runner := source.WithEnvVariable("DEBIAN_FRONTEND", "noninteractive").
		WithExec([]string{"sh", "-c", "/src/scripts/dagger-setup.sh"})

	// run pre-commit tasks
	out, err := runner.WithWorkdir("/src").WithExec([]string{"pre-commit", "run", "-a"}).
		Stderr(ctx)
	if err != nil {
		panic(err)
	}
	fmt.Println(out)

	// Publish the final container
	ref, err := runner.Publish(ctx, fmt.Sprintf("smana/dagger-tofu-%.0f", math.Floor(rand.Float64()*10000000))) //#nosec G404
	if err != nil {
		panic(err)
	}

	fmt.Printf("Published image to: %s\n", ref)

}
