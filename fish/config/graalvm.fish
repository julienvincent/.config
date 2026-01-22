if type -q mise
    set -gx GRAALVM_HOME $(mise where java@graal)
end
