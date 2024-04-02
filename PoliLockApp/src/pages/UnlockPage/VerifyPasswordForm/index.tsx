import {
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import PasswordForm from "../../../components/PasswordForm";
import { lockOpen } from "ionicons/icons";
import { useMqtt } from "../../../contexts/MqttContext";

const VerifyPasswordForm: React.FC = () => {
  const { publish } = useMqtt();
  const verifySenhaTopic = "daganes/armarios/1/verify";
  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("Publicando para verificar");
    publish(verifySenhaTopic, data.senha);
  };

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle>Verificar Senha</IonCardTitle>
      </IonCardHeader>

      <IonCardContent>
        <PasswordForm
          onSubmit={onSubmit}
          submitBtnText="Destrancar"
          btnIcon={lockOpen}
          placeholder="Senha"
        />
      </IonCardContent>
    </IonCard>
  );
};

export default VerifyPasswordForm;
