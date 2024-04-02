import React from "react";
import {
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
} from "@ionic/react";

import { useEffect, useState } from "react";
import { SupabaseClient, createClient } from "@supabase/supabase-js";
import { SUPABASE_URL, SUPABASE_API_KEY } from "../../../config";

import LogsList from "./LogsList";

const LogsCard: React.FC = () => {
  const [supabase, setSupabase] = useState<SupabaseClient | undefined>();
  const [logs, setLogs] = useState<any>();

  useEffect(() => {
    const supabase = createClient(SUPABASE_URL, SUPABASE_API_KEY);
    setSupabase(supabase);

    const getLogs = async () => {
      setLogs([
        {
          message: "Error: Could not connect to database",
          date: "2024-04-02T08:30:15Z",
        },
        {
          message: "Warning: Disk space running low",
          date: "2024-04-02T09:15:47Z",
        },
        {
          message: "Info: User 'john_doe' logged in",
          date: "2024-04-02T10:05:22Z",
        },
        {
          message: "Error: Server crashed unexpectedly",
          date: "2024-04-02T11:20:10Z",
        },
      ]);
    };

    getLogs();
  }, []);

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle>Monitoramento</IonCardTitle>
      </IonCardHeader>

      <LogsList logs={logs} />
    </IonCard>
  );
};

export default LogsCard;
